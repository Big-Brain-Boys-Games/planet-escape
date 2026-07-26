extends CharacterBody3D

@export var speed : float = 1.5
@export var rotating : float = 2
@export var target_area : float = 1

var player : Node3D
var animation : AnimationPlayer

func set_target():
	$target.global_position = get_parent().get_node("fish_target").global_position + Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1)) * 2

func _ready() -> void:
	set_target()
	animation = get_node("angry_fish/AnimationPlayer")
	player = get_tree().get_first_node_in_group("player")

var rot_vel = Quaternion.from_euler(Vector3(0,0,0))

var rotate_away_timer : float = 0
var attack_timer = 0
func _process(delta: float) -> void:
	
	rotate_away_timer -= delta
	var allow_rotate : float = 1
	var speed_mul = 1
	if player.global_position.distance_to(global_position) > 10:
		animation.current_animation = "swim"
		
		var diff : Vector3 = $target.global_position - global_position;
		if diff.length_squared() < target_area:
			set_target()
		
		attack_timer = 0
	else:
		#aggro
		var progress = (max(global_basis.z.dot(global_position.direction_to(player.global_position))*4, 0)+1)
		attack_timer += delta
		#print(attack_timer)
		
		if attack_timer > 6:
			attack_timer = -1
			#animation.stop()
		elif attack_timer > 4:
			animation.current_animation = "bite"
			speed_mul = 1.5
			allow_rotate = 0.3
			#print("attacking!")
			#print("stopping")
		elif attack_timer > 0:
			attack_timer += delta * progress * max((4-global_position.distance_to(player.global_position))*3, 1)
			animation.current_animation = "swim"
			#swim towards player
			$target.global_position = player.global_position
		else:
			velocity = velocity.lerp(Vector3.ZERO, delta*1)
			move_and_slide()
			return
	
	if rotate_away_timer > 0:
		allow_rotate = 2
	
	var rot = quaternion
	look_at($target.global_position)
	if rotate_away_timer < 0:
		quaternion = rot.slerp(quaternion, delta*rotating * allow_rotate)
	else:
		quaternion = rot.slerp(-quaternion, delta*rotating * allow_rotate)
	
	velocity = velocity.lerp(-global_basis.z * speed * speed_mul, delta * 5)
	move_and_slide()
	#var rot_diff = quaternion * rot.inverse()
	#rot_vel = rot_vel.slerp(rot_diff, delta)
	#quaternion = rot * rot_vel
	
	#print("target : ", $target.global_position)
	#print("fish : ", global_position)
	
	#print("direction: ", diff.normalized() )
	#global_translate(-global_basis.z * delta * speed)


func _on_area_3d_body_entered(body: Node3D) -> void:
	
	
	if body.is_in_group("player"):
		if attack_timer > 4:
			body.take_damage(35)
			body.velocity = (-global_basis.z + global_basis.x*0.5) * 10
		
		rotate_away_timer = 1.5
	pass # Replace with function body.
