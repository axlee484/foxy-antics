using Godot;
using System;

public partial class Hurting : PlayerState
{
    private AnimatedSprite2D animatedSprite2D;
    private void PlayHurtingAnimation()
    {
        animatedSprite2D.Play("hurt");
    }
    public override void Enter()
    {
        animatedSprite2D = Player.animatedSprite2D;
        PlayHurtingAnimation();
    }
}
