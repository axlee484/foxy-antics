using Godot;
using System;

public partial class HealthComponent : Node
{
    [Export] public int MAX_HEALTH = 100;
    [Signal] public delegate void DiedEventHandler();
    public int currentHealth = 100;

    public override void _Ready()
    {
        currentHealth = MAX_HEALTH;
    }
    public void TakeDamage(int damage)
    {
        currentHealth -= damage;
        if (currentHealth <= 0)
        {
            currentHealth = 0;
            EmitSignal(SignalName.Died);

        }
    }
    public void Heal(int amount)
    {
        currentHealth += amount;
        if (currentHealth > MAX_HEALTH)
        {
            currentHealth = MAX_HEALTH;
        }
    }
}
