using Godot;
using System;

public partial class Jumping : PlayerState
{
    private AnimatedSprite2D animatedSprite2D;

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
        Player.Velocity = new Vector2(xInput * Player.Speed, Player.Velocity.Y);
        if (xInput != 0)
            animatedSprite2D.FlipH = xInput < 0;
        if (Player.Velocity.Y >= 0)
        {
            EmitSignal(State.SignalName.ChangeState, "Falling");
            return;
        }
    }
    public override void Enter()
    {
        animatedSprite2D = Player.animatedSprite2D;

        if (Player.jumpsLeft == 0)
        {
            EmitSignal(State.SignalName.ChangeState, "Falling");
            return;
        }

        Player.Velocity = new Vector2(Player.Velocity.X, Player.JumpForce);
        Player.jumpsLeft--;

        PlayJumpingAnimation();
    }
}
