using Godot;
using System;

public partial class Moving : PlayerState
{
    private AnimatedSprite2D animatedSprite2D;

    private void PlayMovingAnimation()
    {
        animatedSprite2D.Play("moving");
    }
    public override void Enter()
    {
        animatedSprite2D = Player.animatedSprite2D;
        PlayMovingAnimation();
    }

    public override void PhysicsProcess(double delta)
    {
        var input = Input.GetAxis("left", "right");
        if (input == 0)
        {
            EmitSignal(State.SignalName.ChangeState, "Idle");
            Player.Velocity = new Vector2(0, Player.Velocity.Y);
            return;
        }

        if (!Player.IsOnFloor())
        {
            EmitSignal(State.SignalName.ChangeState, "Falling");
            return;
        }
        if (input > 0) animatedSprite2D.FlipH = false;
        else animatedSprite2D.FlipH = true;

        var velocity = new Vector2(Player.Speed * input, Player.Velocity.Y);
        Player.Velocity = velocity;
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
