// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
var width = 520,
    height = 600;

//Map projection
var projection = d3.geo.mercator()
    .scale(2734.5663919865196)
    .center([-119.306607,37.418968243587926]) //projection center
    .translate([width/2,height/2]) //translate to center the map in view

//Generate paths based on projection
var path = d3.geo.path()
    .projection(projection);

//Create an SVG
var svg = d3.select("body").append("svg")
    .attr("width", width)
    .attr("height", height);

//Group for the map features
var features = svg.append("g")
    .attr("class","features");

//Create zoom/pan listener
//Change [1,Infinity] to adjust the min/max zoom scale
var zoom = d3.behavior.zoom()
    .scaleExtent([1, Infinity])
    .on("zoom",zoomed);

svg.call(zoom);

d3.json("/assets/ca.geojson",function(error,geodata) {
  if (error) return console.log(error); //unknown error, check the console

  //Create a path for each map feature in the data
  features.selectAll("path")
    .data(geodata.features)
    .enter()
    .append("path")
    .attr("d",path)
    .on("click",clicked);

});

// Add optional onClick events for features here
// d.properties contains the attributes (e.g. d.properties.name, d.properties.population)
function clicked(d,i) {

}


//Update map on zoom/pan
function zoomed() {
  features.attr("transform", "translate(" + zoom.translate() + ")scale(" + zoom.scale() + ")")
      .selectAll("path").style("stroke-width", 1 / zoom.scale() + "px" );
}
