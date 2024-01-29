# stable-retro-stuff

---
# step -> Allows you to easily run the stable-restro script to build a model in steps of a specific incriment.

### For Example 
```
step-stable-retro 5000000 config.txt   
```
Would run SuperMarioBros-Nes for 5 million frames starting with the 'SuperMarioBros-Nes-Base model' and create a model named 'SuperMarioBros-Nes-Base+5mil'
The next loop would be for 5 million frames starting with the 'SuperMarioBros-Nes-Base+5mil model'

config.txt
```
Configuration for Mario Model Training
output_basedir="/data/OUTPUT/"
model_dir="/data/models/SuperMarioBros/steps/"
base_model="SuperMarioBros-Nes-Base"
env="SuperMarioBros-Nes"
state="Level1-1.state"
random_state=true

List of states for random selection
states=(
    "Level1-1.state"
    "Level2-1-clouds-easy.state"
    "Level3-1.state"
    "Level4-1.state"
    "Level5-1.state"
    "Level6-1.state"
    "Level7-1.state"
    "Level8-1.state"
)
```

# SuperMarioBros-Nes Contains memory locations fro vairous stats in the game. It also includes a custom .lua script to assign rewards when an AI is playing the game.
