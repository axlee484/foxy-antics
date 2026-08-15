using Godot;
using System;

public partial class Idle : PlayerState
{

    private void PlayIdleAnimation()
    {
        var animatedSprite2D = Player.animatedSprite2D;
        animatedSprite2D.Play("idle");
    }
    public override void Enter()
    {
        PlayIdleAnimation();
    }
    public override void _UnhandledInput(InputEvent @event)
    {
        base._UnhandledInput(@event);

    }
}
