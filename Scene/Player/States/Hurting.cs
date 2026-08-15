using Godot;
using System;

public partial class Hurting : PlayerState
{
    private AnimationPlayer animationplayer;
    private void PlayHurtingAnimation()
    {
        animationplayer.Play("hurt");
    }
    // private void ApplyJump()
    // {
    //     Player.Velocity = new Vector2(Player.Velocity.X * (-1) / Mathf.Abs(Player.Velocity.X) * Player.HurtPushForce, Player.HurtJumpForce);
    // }

    public override void Enter()
    {
        animationplayer = Player.animationPlayer;
        PlayHurtingAnimation();
        EmitSignal(State.SignalName.ChangeState, "Idle");
    }

}
