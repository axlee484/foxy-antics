using Godot;
using System.Collections.Generic;

public partial class StateMachine : Node
{
    [Export] public State initialState;
    private State currentState;
    private readonly Dictionary<string, State> states = [];
    public override void _Ready()
    {
        foreach (var child in GetChildren())
        {
            if (child is State state)
            {
                states.Add(state.Name, state);
                state.ChangeState += ChangeState;
            }
        }
    }
    public override void _Process(double delta)
    {
        base._Process(delta);
        currentState.Process(delta);
    }
    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);
        currentState.PhysicsProcess(delta);
    }

    public void Start()
    {
        currentState = initialState;
        initialState.Enter();
    }
    public void ChangeState(string newState)
    {
        currentState.Exit();
        currentState = states[newState];
        currentState.Enter();
    }
}
