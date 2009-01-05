/***
 * Excerpted from "Prototype and script.aculo.us",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/cppsu for more book information.
***/

// Borrowed from script.aculo.us' effects.js...
Element.addMethods({
  collectTextNodes: function(element) {  
    return $A($(element).childNodes).collect( function(node) {
      return (node.nodeType==3 ? node.nodeValue : 
        (node.hasChildNodes() ? Element.collectTextNodes(node) : ''));
    }).flatten().join('');
  } 
});



var TableSorter = Class.create({
  initialize: function(element) {
    this.element = $(element);
    this.sortIndex = -1;
    this.sortOrder = 'asc';
    this.initDOMReferences();
    this.initEventHandlers();
  }, // initialize

  initDOMReferences: function() {
    var head = this.element.down('thead');
    var body = this.element.down('tbody');
    if (!head || !body)
      throw 'Table must have a head and a body to be sortable.';
    this.headers = head.down('tr').childElements(); 
    this.headers.each(function(e, i) { 
      e._colIndex = i;
    });
    this.body = body;
  }, // initDOMReferences

  initEventHandlers: function() {
    this.handler = this.handleHeaderClick.bind(this); 
    this.element.observe('click', this.handler);
  }, // initEventHandlers



  handleHeaderClick: function(e) {
    var element = e.element();
    if (!('_colIndex' in element)) {
      element = element.ancestors().find(function(elt) { 
        return '_colIndex' in elt;
      });
      if (!((element) && '_colIndex' in element))
        return;
    }
    this.sort(element._colIndex);
  }, // handleHeaderClick



  adjustSortMarkers: function(index) {
    if (this.sortIndex != -1)
      this.headers[this.sortIndex].removeClassName('sort-' +
        this.sortOrder);
    if (this.sortIndex != index) {
      this.sortOrder = 'asc';
      this.sortIndex = index;
    } else
      this.sortOrder = ('asc' == this.sortOrder ? 'desc' : 'asc');
    this.headers[index].addClassName('sort-' + this.sortOrder);
  }, // adjustSortMarkers

  sort: function(index) {
    this.adjustSortMarkers(index);
    var rows = this.body.childElements();
    rows = rows.sortBy(function(row) { 
      var value = row.childElements()[this.sortIndex].collectTextNodes(); 
      var intValue = parseInt(value);
      if (isNaN(intValue)) {
          return value;
      } else {
          return intValue;
      }
      
    }.bind(this));
    if ('desc' == this.sortOrder)
      rows.reverse();
    rows.reverse().each(function(row, index) { 
      if (index > 0)
        this.body.insertBefore(row, rows[index - 1]);
    }.bind(this));
    rows.reverse().each(function(row, index) {
      row[(0 == index % 2 ? 'add' : 'remove') + 'ClassName']('even'); 
    });
  } // sort
}); // TableSorter


document.observe('dom:loaded', function() {
  $$('table').each(function(table) { new TableSorter(table); }); 
});

