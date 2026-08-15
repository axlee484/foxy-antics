using Godot;
using System;
using System.Collections.Generic;

public partial class HitBoxComponent : Area2D
{
    [Export] public int Damage = 0;
    [Export] public float DamageTime = 0.5f; //float 
    private readonly Dictionary<HurtBoxComponent, Timer> hurtBoxTimers = [];

    private void DealDamage(HurtBoxComponent hurtBox)
    {
        hurtBox.EmitSignal(HurtBoxComponent.SignalName.DamageTaken, Damage);
    }
    public void OnAreaEntered(Area2D area)
    {
        if (area is HurtBoxComponent hurtBox)
        {
            GD.Print("Hit");
            DealDamage(hurtBox);
            var timer = new Timer { WaitTime = DamageTime, OneShot = false, Autostart = false };
            AddChild(timer);
            timer.Timeout += () => DealDamage(hurtBox);
            timer.Start();
            hurtBoxTimers[hurtBox] = timer;
        }
    }
    public void OnAreaExited(Area2D area)
    {
        if (area is HurtBoxComponent hurtBox)
        {
            hurtBoxTimers[hurtBox].Stop();
            hurtBoxTimers[hurtBox].QueueFree();
            hurtBoxTimers.Remove(hurtBox);
        }
    }
}
