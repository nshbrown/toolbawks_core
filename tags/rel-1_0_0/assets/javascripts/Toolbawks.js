Toolbawks = {};

Toolbawks.info = {
  VERSION : '1.0.1',
  
  msg_box : false,
  
  create_box : function(t, s){
    return ['<div class="msg">',
            '<div class="x-box-tl"><div class="x-box-tr"><div class="x-box-tc"></div></div></div>',
            '<div class="x-box-ml"><div class="x-box-mr"><div class="x-box-mc"><h3>', t, '</h3>', s, '</div></div></div>',
            '<div class="x-box-bl"><div class="x-box-br"><div class="x-box-bc"></div></div></div>',
            '</div>'].join('');
  },
  
  msg : function(title, format){
    if (!format) {
      format = title;
      title = "";
    }
    
    if(!Toolbawks.info.msg_box){
      Toolbawks.info.msg_box = Ext.DomHelper.insertFirst(document.body, {id:'msg-div'}, true);
    }
    
    Toolbawks.info.msg_box.alignTo(document, 't-t');
    var s = String.format.apply(String, Array.prototype.slice.call(arguments, 1));
    var m = Ext.DomHelper.append(Toolbawks.info.msg_box, {html: Toolbawks.info.create_box(title, s)}, true);
    m.slideIn('t').pause(1).slideOut('t', {remove: true});
  }
};