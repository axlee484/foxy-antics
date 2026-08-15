using Godot;
using System;

public partial class HurtBoxComponent : Area2D
{
    [Signal] public delegate void DamageTakenEventHandler(int damage);
}
