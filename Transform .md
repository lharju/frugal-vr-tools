# Head Rotation as Input

## Presentations of Rotation

- Euler Angles
	- Good for modifying rotation, but not reading rotation
- Quarternion
	- Unintuitive
- Transform
	- Great for our use case

## So what is a Transform

[https://docs.unity3d.com/6000.4/Documentation/ScriptReference/Transform.html](https://docs.unity3d.com/6000.4/Documentation/ScriptReference/Transform.html)
 
You can think of it as the three arrows you see in the editor to modify any objects position.
Transform defines the objects rotation, scale and shear; but we only care about the rotation.

![](https://docs.unity3d.com/6000.4/Documentation/uploads/Main/TransformExample2.png)
Three vectors that change whenever the camera/head moves

## Vector math review

- Dot product of two vector is a scalar
	 - $a \cdot b = \sum_{i=1}^{n} a_i b_i$
- Dot product of two unit vectors is in range $[-1, 1]$
	- At 1 vectors are parallel
	- At -1 vector are anti parallel
	- So basically a measure of alignment between two vectors

## And how do you use it for Input

- Head Roll
	- `roll = Vector3.Dot(camera.transform.right, Vector3.up);`
- Tilt of head to floor
	- `x = Vector3.Dot(camera.transform.up, Vector3.right);`
	- `z = Vector3.Dot(camera.transform.up, Vector3.forward);`
- Head projected to arbitrary plane defined by two vectors
	- `x = Vector3.Dot(camera.transform.forward, plane.x);`
	- `y = Vector3.Dot(camera.transform.forward, plane.y);`