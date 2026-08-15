using Godot;
using System;

public partial class Jumping : PlayerState
{
    private AnimatedSprite2D animatedSprite2D;

    private int jumpsLeft;
    private void PlayJumpingAnimation()
    {
        animatedSprite2D.Play("jump");
    }

    public override void HandleInput(InputEvent @event)
    {
        if (@event.IsActionPressed("jump")) EmitSignal(State.SignalName.ChangeState, "Jumping");
    }

    public override void PhysicsProcess(double delta)
    {
        var xInput = Input.GetAxis("left", "right");
        Player.Velocity = new Vector2(xInput * Player.SPEED, Player.Velocity.Y);
        if (Player.IsOnFloor())
        {
            EmitSignal(State.SignalName.ChangeState, "Idle");
            return;
        }
    }
    public override void Enter()
    {
        animatedSprite2D = Player.animatedSprite2D;

        if (Player.IsOnFloor()) jumpsLeft = Player.MAX_JUMPS_AVAILABLE;
        if (jumpsLeft <= 0) return;

        Player.Velocity = new Vector2(0, Player.JUMP_FORCE);
        jumpsLeft--;

        PlayJumpingAnimation();
    }
}
