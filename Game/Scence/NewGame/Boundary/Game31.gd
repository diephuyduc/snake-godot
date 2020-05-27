extends Node2D
var snake = [Vector2(5, 1)]
var feed = Vector2()
var step =0
var font
var font_size = 40
var game_over = false
var up = Vector2(0, -1); var down = Vector2(0,1); var left = Vector2(-1, 0); var right = Vector2(1, 0)
var direction = down
var height = 600; var width = 1000
var root_coordinates = Vector2(0,0)
var gap = font_size - font_size/2
var award = Vector2(0,0); var is_scale = false; var is_pause = false; var present_pausing_position = Vector2()
var number_of_action =0;
func _ready():
	font = load("res://fonts/BodoniMTBlack.fnt")
	set_process_input(true)
	set_physics_process(true)
	
func move_snake():
	print(str(snake[0].x) +"  "+ str(root_coordinates.x))
	print(str(snake[0].y) +"  "+ str(root_coordinates.y))
	if  (snake[0].x*gap+direction.x ) >int(root_coordinates.x) and (snake[0].x*gap +direction.x +gap)<width+ root_coordinates.x:
		if (snake[0].y*gap+direction.y-gap) >int(root_coordinates.y) and (snake[0].y*gap +direction.y) <height+root_coordinates.y: 
			snake.push_front(snake[0]+direction)
			snake.pop_back()
		else: game_over = true
	else:
		game_over = true
	

func _input(event):
	if Input.is_action_pressed("ui_down") : 
		direction = down
		number_of_action = number_of_action +1
	if Input.is_action_pressed("ui_up") : 
		direction = up
		number_of_action = number_of_action +1
	if Input.is_action_pressed("ui_left") :
		 direction = left
		 number_of_action = number_of_action +1
	if Input.is_action_pressed("ui_right") : 
		direction = right
		number_of_action = number_of_action +1
	if Input.is_action_pressed("ui_accept"):
		if is_pause == false:
			present_pausing_position = direction
			direction = Vector2(0,0)
			$PopupMenu2.show()
			is_pause = true
		else:
			direction = present_pausing_position
			$PopupMenu2.hide()
			is_pause = false
	update()
func food():
	if (feed.x) <root_coordinates.x || (feed.x)>width+ root_coordinates.x:
			if (feed.y) <root_coordinates.y || (feed.y) >height+root_coordinates.y: 
				feed = Vector2(0,0)
	if feed == Vector2(0,0):
		randomize()
		var xx = int(rand_range(root_coordinates.x+gap,root_coordinates.x +width-gap))
		var yy = int (rand_range(root_coordinates.y+gap , root_coordinates.y+height-gap))
		feed = Vector2 (xx, yy)
	if feed.x >=(snake[0].x*gap -gap) and feed.x <= (snake[0].x*gap+gap) and feed.y >= (snake[0].y*gap -gap) and feed.y<=(snake[0].y*gap +gap) :
		snake.push_front(snake[0] + direction)
		get_node("showscore").text = str(snake.size())
		feed = Vector2(0,0)
func run_in_boundary():
	
	if award == Vector2(0,0) and (number_of_action +3)% 7==0 and game_over ==false:
		randomize()
		is_scale = true
		var xx = int(rand_range(root_coordinates.x+gap,root_coordinates.x +width-gap))
		var yy = int (rand_range(root_coordinates.y+gap , root_coordinates.y+height-gap))
		award = Vector2 (xx, yy)
	if award.x >=(snake[0].x*gap -gap) and award.x <= (snake[0].x*gap+gap) and award.y >= (snake[0].y*gap -gap) and award.y<=(snake[0].y*gap +gap) :
		is_scale = false
		award = Vector2(0,0)
	if number_of_action % 7 ==0 and is_scale == true and game_over == false:
		root_coordinates.x = int( (width*0.09)/2)
		root_coordinates.y = int ((height*0.09)/2)
		height = height - height *0.005
		width = width -width*0.005
	elif (number_of_action -1)%7 ==0:
		award = Vector2(0,0)
	update()

func _physics_process(delta):
	
	step = step + delta
	if(step >0.25):
		run_in_boundary()
		food()
		
		if game_over ==false: move_snake()
		step =0.1
	update()
	end_game()
	

func _draw():
	get_node("noaction").text = str(number_of_action)
	for i in range(0, snake.size()): 
		 draw_string(font, Vector2(snake[i].x*gap, snake[i].y*gap),"o", Color(0,0,1))
	draw_string(font, Vector2(feed), "o", Color(1,0,1)) 
	draw_string(font, Vector2(award), "*", Color(1,0,0)) 
	draw_rect(Rect2(root_coordinates.x, root_coordinates.y, width, height), Color("#000FFF"), false)
	draw_rect(Rect2(0, 0, 1100, 700), Color("#000FFF"), false )
	

func end_game():
	if game_over == true:
		get_node("PopupMenu/lscore2").text = str(snake.size())
		get_node("PopupMenu").show()



func _on_playagain_pressed():
	get_tree().change_scene("res://Scence/NewGame/Boundary/Game3.tscn")
	pass # Replace with function body.


func _on_savenickname_pressed():
	var nickname = $PopupMenu/nickname.text
	get_node("PopupMenu/savenickname/Label").text = "saved"
	if nickname != null:
		var file = File.new()
		file.open("res://Assets/Score/score_boundary.txt", File.READ_WRITE)
		file.seek_end()
		file.store_line(str(nickname)+"\t\t"+str(snake.size()))
		file.close()
	


func _on_quit_pressed():
	get_tree().change_scene("res://Scence/NewGame/Boundary/menuplay3.tscn")
