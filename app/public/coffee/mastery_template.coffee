$.get "../../public/jade/mastery.jade", (template) ->
	template = jade.compile(template, pretty: true)
	contents = document.open("text/html", "replace")
	contents.write template()
	contents.close()
$.get "../../public/styl/mastery.styl", (styl) ->
	stylus.render styl, (err, css) ->
		styl = document.createElement("style")
		styl.innerHTML = css # Compiled Stylus
		document.body.appendChild(styl)