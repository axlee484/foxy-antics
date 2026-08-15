using Godot;
using System;

public partial class Player : CharacterBody2D
{
    private StateMachine stateMachine;
    public AnimatedSprite2D animatedSprite2D;

    public override void _Ready()
    {
        stateMachine = GetNode<StateMachine>("StateMachine");
        animatedSprite2D = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
        stateMachine.Start();

    }
}
