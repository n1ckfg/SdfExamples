"use strict";

let shader_test;

function preload() {
	shader_test = loadShader("./js/shaders/blank.vert", "./js/shaders/sdf.frag");
}

function setup() {
	createCanvas(640, 480, WEBGL);
}

function draw() {
	shader(shader_test);
	shader_test.setUniform("iResolution", [width, height]);
	rect(0, 0, width, height, 1, 1);
}