using Godot;
using System;

public partial class Falling : PlayerState
{
    AnimatedSprite2D animatedSprite2D;

    private void PlayFallingAnimation()
    {
        animatedSprite2D.Play("fall");
    }
    public override void Enter()
    {
        if (Player.IsOnFloor())
        {
            EmitSignal(State.SignalName.ChangeState, "Idle");
            return;
        }
        animatedSprite2D = Player.animatedSprite2D;
        PlayFallingAnimation();
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
    public override void HandleInput(InputEvent @event)
    {
        if (@event.IsActionPressed("jump"))
        {
            EmitSignal(State.SignalName.ChangeState, "Jumping");
            return;
        }
    }
}
