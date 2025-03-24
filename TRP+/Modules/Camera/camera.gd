extends Camera2D

@export var zoomSpeed : float = 10.0
var zoomMin : Vector2 = Vector2(0.5, 0.5)
var zoomMax : Vector2 = Vector2(5.0, 5.0)
var zoomTarget : Vector2

var dragStartMousePos = Vector2.ZERO
var dragStartCameraPos = Vector2.ZERO
var isDragging : bool = false

var cameraPanMargin : int = 16
var cameraEdgeSpeed : float = 1000.0

func _ready() -> void:
	zoomTarget = zoom
	

func _process(delta: float) -> void:
	zoom_camera(delta)
	simple_pan(delta)
	edge_pan(delta)
	click_drag()

func zoom_camera(delta : float) -> void:
	if Input.is_action_just_pressed("ui_mouse_scrollup"):
		zoomTarget *= 1.1
		
	elif Input.is_action_just_pressed("ui_mouse_scrolldown"):
		zoomTarget *= 0.9
		
	zoomTarget = clamp(zoomTarget, zoomMin, zoomMax)
	zoom = zoom.slerp(zoomTarget, zoomSpeed * delta)

func simple_pan(delta : float) -> void:
	var moveAmount = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		moveAmount.x += 1
	if Input.is_action_pressed("ui_left"):
		moveAmount.x -= 1
	if Input.is_action_pressed("ui_up"):
		moveAmount.y -= 1
	if Input.is_action_pressed("ui_down"):
		moveAmount.y += 1
	
	moveAmount = moveAmount.normalized()
	position += moveAmount * delta * 1000 * (1 / zoom.x)

func edge_pan(delta : float) -> void:
	var viewportCurrent : Viewport = get_viewport()
	var panDirection : Vector2 = Vector2(-1, -1)
	var viewportVisibleRect : Rect2 = Rect2(viewportCurrent.get_visible_rect())
	var viewportSize : Vector2 = viewportVisibleRect.size
	var currentMousePos : Vector2 = viewportCurrent.get_mouse_position()
	
	# For X Axis
	if (currentMousePos.x < cameraPanMargin) or (currentMousePos.x > viewportSize.x - cameraPanMargin):
		if (currentMousePos.x > viewportSize.x / 2.0):
			panDirection.x = 1
		position.x += panDirection.x * (cameraEdgeSpeed / zoom.x) * delta
		
	# For Y Axis
	if (currentMousePos.y < cameraPanMargin) or (currentMousePos.y > viewportSize.y - cameraPanMargin):
		if (currentMousePos.y > viewportSize.y / 2.0):
			panDirection.y = 1
		position.y += panDirection.y * (cameraEdgeSpeed / zoom.y) * delta


func click_drag() -> void:
	if !isDragging and Input.is_action_just_pressed("ui_pan"):
		dragStartMousePos = get_viewport().get_mouse_position()
		dragStartCameraPos = position
		isDragging = true
		
	if isDragging and Input.is_action_just_released("ui_pan"):
		isDragging = false
		
	if isDragging:
		var moveVector = get_viewport().get_mouse_position() - dragStartMousePos
		position = dragStartCameraPos - moveVector * 1 / zoom.x
	
