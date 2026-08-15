using Godot;
using System;

public partial class Player : CharacterBody2D
{
    private StateMachine stateMachine;
    public AnimatedSprite2D animatedSprite2D;
    private Label debugLabel;
    [Export] public float GRAVITY = 980.0f;
    [Export] public float JUMP_FORCE = -400.0f;
    [Export] public int MAX_JUMPS_AVAILABLE = 2;
    [Export] public float SPEED = 100.0f;
    public int jumpsLeft = 0;

    public override void _Ready()
    {

        stateMachine = GetNode<StateMachine>("StateMachine");
        animatedSprite2D = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
        debugLabel = GetNode<Label>("DebugLabel");


        stateMachine.Start();
    }
    private void ApplyGravity(double delta)
    {
        Velocity += new Vector2(0, GRAVITY * (float)delta);
    }
    public override void _PhysicsProcess(double delta)
    {
        ApplyGravity(delta);
        MoveAndSlide();
    }

    public override void _Process(double delta)
    {
        Debug();
    }



    private void Debug()
    {
        string debugText = "";
        debugText += $"Velocity: {Velocity}\n";
        debugText += $"Is on floor: {IsOnFloor()}\n";
        debugText += $"State: {stateMachine.currentState.Name}\n";
        debugLabel.Text = debugText;
    }
}
