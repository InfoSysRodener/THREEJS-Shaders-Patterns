import '../style.css'
import * as THREE from 'three';
import * as dat from 'dat.gui';
import SceneManager from './sceneManager/scene';
import gsap from 'gsap';

import fragmentShader from './shaders/pattern/fragment.glsl?raw'
import vertexShader from './shaders/pattern/vertex.glsl?raw'
const gui = new dat.GUI();

//scene
const canvas = document.querySelector('#canvas');
const scene = new SceneManager(canvas);
let conf = { color : '#0f0f0f' }; 
scene.scene.background.set(conf.color);
scene.addOrbitControl();
scene.addFog(1,100,conf.color);

//fog GUI
const fogFolder = gui.addFolder('FOG');
fogFolder.add(scene.scene.fog, 'near').min(1).max(100).step(0.01).listen();
fogFolder.add(scene.scene.fog, 'far').min(1).max(100).step(0.01).listen();
fogFolder.addColor(conf, 'color').onChange((color)=>{
	scene.scene.fog.color.set(color);
	scene.scene.background.set(color);
	// scene.scene.children
	// 	.filter(obj => obj.name === 'floor')[0]
	// 	.material.color.set(color)
});
const axesHelper = new THREE.AxesHelper(5);

//lights
const directionalLight = new THREE.DirectionalLight(0xFFFFFF,1);
directionalLight.position.set(10,10,10);
scene.add(directionalLight);
const ambiantLight = new THREE.AmbientLight(0xFFFFFF,1);
scene.add(ambiantLight);

let uniforms = {
	u_time: { type: "f", value: 1.0 },
	u_resolution: { type: "v2", value: new THREE.Vector2() },
	u_mouse: { type: "v2", value: new THREE.Vector2() }
};

//geometry
const width = 5;  
const height = 5;   
const geometry = new THREE.SphereGeometry(5, 32,32);
const material = new THREE.ShaderMaterial({
	uniforms:uniforms,
	vertexShader:vertexShader,
	fragmentShader:fragmentShader
});
const plane = new THREE.Mesh(geometry,material);
plane.name = 'floor';
// plane.rotation.x = Math.PI * 1.50;
scene.add(plane);


gui.add(material, 'wireframe').name('Plane WireFrame');
gui.add(uniforms.u_resolution.value, 'x').min(1).max(window.innerWidth);
gui.add(uniforms.u_resolution.value, 'y').min(1).max(window.innerHeight);
const clock = new THREE.Clock();

const animate = () => {
	const elapsedTime = clock.getElapsedTime();

	material.uniforms.u_time.value = elapsedTime;


	scene.onUpdate();
	scene.onUpdateStats();
	requestAnimationFrame( animate );
};

animate();