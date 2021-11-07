extends KinematicBody

# physics
var moveSpeed : float = 5.0
var jumpForce : float = 5.0
var gravity : float = 10.0

# camMovement
var minLookAngle : float = -90.0
var maxLookAngle : float = 90.0
var lookSpeed : float = 50.0

#vectors
var vel : Vector3 = Vector3()
var mouseDelta : Vector2 = Vector2()

#components
onready var camera : Camera = get_node("Camera")

func _ready():
	#hide and lock the little cursor like its a anime woman
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	
	#reset x and z velocities
	vel.x = 0
	vel.z = 0

	var input = Vector2()
	
	#movement inputs
	if Input.is_action_pressed("move_backward"):
		input.y += 1
	if Input.is_action_pressed("move_forward"):
		input.y -= 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
		
	input = input.normalized()
	
	#ugh directions
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
		
	var relativeDir = (forward * input.y + right * input.x)
		
	#velocity shit		
	vel.x = relativeDir.x * moveSpeed
	vel.z = relativeDir.z * moveSpeed
	
	#gravity shit
	vel.y -= gravity * delta
	
	#un-vegetablizing the player (actually moving the player (0_0)
	vel = move_and_slide(vel, Vector3.UP)
	
	#recruiting him to the NBA BIG LEAUGES LESS GOOOOO (jumping)
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y = jumpForce
		
func _process(delta):
	
	#rotate camera along X AXIS YOU IMBACILE
	camera.rotation_degrees.x -= mouseDelta.y * lookSpeed * delta
	
	#clamp camera x rot. axis
	camera.rotation_degrees.x - clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	
	#rotate banana across y axis *moans*
	rotation_degrees.y -= mouseDelta.x * lookSpeed * delta
	
	#reset your mo- i mean mouse delta vector
	mouseDelta = Vector2()
		
func _input(event):
	
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
