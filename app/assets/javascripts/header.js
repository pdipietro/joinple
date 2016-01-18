$(document).ready(function($){
	a=$.cookie("windowWidth");
	if (a === undefined || a === null) {
  	document.cookie='width='+screen.width;
  	document.cookie='height='+screen.height;
 	document.cookie='pixelRatio='+("devicePixelRatio" in window ? devicePixelRatio : "1.0");
  	document.cookie='windowWidth='+$(window).width();
    document.cookie='windowHeight='+$(window).height();
    document.location.replace(document.baseURI);
  }
});
