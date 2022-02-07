function inject(json) {
	const elem = document.querySelector('#content')
	const content = [];
	Object.keys(json).forEach( i => {
		content.push(`<h1>${i}</h1>`);
		content.push(injectLinks( json[i] ))
	} )
	elem.innerHTML = content.join('')
}

function injectLinks( obj ) {
	const list = []
	Object.keys(obj).forEach( i => {
		list.push( `<li><a href="${obj[i]}">${i}</a></li>` );
	})
	return list.join('')
}
const xhttp = new XMLHttpRequest();
xhttp.onload = function() {
  inject( JSON.parse( this.responseText ) )
}
xhttp.open("GET", "bookmarks.json");
xhttp.send();
