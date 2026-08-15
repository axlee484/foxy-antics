using Godot;
using System;

public partial class HurtBoxComponent : Area2D
{
    [Signal] public delegate void DamageTakenEventHandler(int damage);
    public void OnAreaEntered(Area2D area)
    {
        if (area is HitBoxComponent hitBox)
        {
            EmitSignal(SignalName.DamageTaken, hitBox.DAMAGE);
        }
    }
}
