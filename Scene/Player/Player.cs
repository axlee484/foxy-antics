using Godot;
using System;

public partial class Player : CharacterBody2D
{
    private StateMachine stateMachine;
    public AnimatedSprite2D animatedSprite2D;
    public AnimationPlayer animationPlayer;
    private Label debugLabel;
    [Export] public float Gravity = 980.0f;
    [Export] public float JumpForce = -400.0f;
    [Export] public float HurtJumpForce = -400.0f;
    [Export] public float HurtPushForce = 400.0f;
    [Export] public int MaxJumpsAvailable = 2;
    [Export] public float Speed = 100.0f;
    [Export] public HealthComponent HealthComponent;
    [Export] public HurtBoxComponent HurtBoxComponent;
    [Export] public HitBoxComponent HitBoxComponent;
    public int jumpsLeft = 0;

    public override void _Ready()
    {

        stateMachine = GetNode<StateMachine>("StateMachine");
        animatedSprite2D = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
        animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");

        debugLabel = GetNode<Label>("DebugLabel");
        HurtBoxComponent.DamageTaken += OnHurt;
        HurtBoxComponent.DamageTaken += HealthComponent.TakeDamage;
        HealthComponent.Died += OnDie;
        stateMachine.Start();
    }

    private void OnHurt(int damage)
    {
        stateMachine.ChangeState("Hurting");
    }
    private void ApplyGravity(double delta)
    {
        Velocity += new Vector2(0, Gravity * (float)delta);
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

    public void OnDie()
    {
        QueueFree();
    }



    private void Debug()
    {
        string debugText = "";
        debugText += $"Velocity: {Velocity}\n";
        debugText += $"Is on floor: {IsOnFloor()}\n";
        debugText += $"State: {stateMachine.currentState.Name}\n";
        debugText += $"Health: {HealthComponent.currentHealth}\n";
        debugLabel.Text = debugText;
    }
}
