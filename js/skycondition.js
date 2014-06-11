<script type="text/javascript">

      //Width and height//Width and height
      var margin = {top: 20, right: 20, left: 20, bottom:10}
      var w = 1000 - margin.left - margin.right;
      var h = 1000 - margin.top - margin.bottom;
      var rowPadding = 10;
      var hrH = 3; //height of each hour
      var dayW = 20; //width of each day
      var dayH = hrH * 24; //height of each day
      
      var colors = ["#b6e6ff", "#a7cadc", "#98aeba", "#899399", "#797979" ] //colors to display sky conditions  
      //L:90, c:36, h:270 to L:51, c:0, h:191 

      d3.csv("https://docs.google.com/spreadsheet/pub?hl=en&hl=en&key=0Ag5aogSBxgxzdExlNnZtSjRLazV0T1dvazBuWjZDMmc&single=true&gid=0&output=csv",
      function(csv) { 
        //Create SVG element
        var svg = d3.select("#chart")
                    .append("svg")
                    .attr("width", w)
                    .attr("height", h);
                    
        svg.selectAll("rect")
           .data(csv)
           .enter()
           .append("rect")
           .attr("x", function(d) {
                return (+d.Day) * dayW + margin.left;
           })
           .attr("y", function(d) {
                    return ((+d.Month-1) * dayH) + ((+d.Hour) * hrH) + margin.top;
           })
           .attr("width", dayW)
           .attr("height", hrH)
           .attr("stroke", "grey")
           .style("fill",function(d) {
                    return colors[(+d.ConvertSky / 2)];})
             
                  });
            </script>