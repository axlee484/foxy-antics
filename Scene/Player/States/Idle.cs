using Godot;
using System;

public partial class Idle : PlayerState
{
    AnimatedSprite2D animatedSprite2D;

    private void PlayIdleAnimation()
    {
        animatedSprite2D.Play("idle");
    }
    public override void Enter()
    {
        animatedSprite2D = Player.animatedSprite2D;
        PlayIdleAnimation();
    }


    public override void PhysicsProcess(double delta)
    {
        if (!Player.IsOnFloor())
        {
            EmitSignal(State.SignalName.ChangeState, "Falling");
            return;
        }
        var input = Input.GetAxis("left", "right");
        if (input != 0)
        {
            EmitSignal(State.SignalName.ChangeState, "Moving");
            return;
        }
    }

    public override void HandleInput(InputEvent @event)
    {
        if (@event.IsActionPressed("jump"))
        {
            EmitSignal(State.SignalName.ChangeState, "Jumping");
        }
    }
}
