#Requires Autohotkey v2.0+

class Animal
{
	type := "mammal"
	hasFur := true
	LegsCount := 0
	location := 0
	direction := ""
	speed := 0

	run(direction)
	{
		this.move(this.speed, direction)
	}

	move(steps, direction)
	{
		this.location += steps
		this.direction := direction
	}

	Sound(freq, duration)
	{
		SoundBeep freq, duration
	}
}

class Dog extends Animal
{
	size := 0
	legsCount := 4
	hasTail := true
	pitch := 0
	duration := 0
	
	__New(breed)
	{
		switch (breed)
		{
		case "Pitbull":
			this.pitch := 300
			this.duration := 500
			this.size := 95
			this.speed := 30
		case "Chiuaua":
			this.pitch := 6000
			this.duration := 200
			this.size := 15
			this.speed := 75

		}
	}

	bark()
	{
		this.Sound(this.pitch, this.duration)
		this.Sound(this.pitch, this.duration)
	}
}

tony := Dog("Pitbull")
chibi := Dog("Chiuaua")

tony.bark()
chibi.bark()

Sleep 1000

MsgBox "Tony: " tony.location "`n" "Chibi: " chibi.location
tony.run("nw")
chibi.run("nw")
MsgBox "Tony: " tony.location "`n" "Chibi: " chibi.location 
