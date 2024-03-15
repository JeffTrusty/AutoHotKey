#Requires Autohotkey v2.0+

class Animal
{
	type := "mammal"
	hasFur := true
	LegsCount := ""
	location := ""
	direction := ""

	run(direction)
	{
		this.move(10, direction)
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

class Cat extends Animal
{
	legsCount := 4
	hasTail := true

	meow()
	{
		this.Sound(6000, 1500)
	}
}

class Bengala extends Cat
{
	meow()
	{
		this.Sound(4000, 900)
	}
}

class Dog extends Animal
{
	legsCount := 4
	hasTail := true

	bark()
	{
		this.Sound(800, 500)
		this.Sound(800, 800)
	}
}


myCat := Bengala()
myDog := Dog()

myCat.meow()
myDog.bark()

sleep 500
myCat.bark() ; this wont do anything because a cat cant bark.