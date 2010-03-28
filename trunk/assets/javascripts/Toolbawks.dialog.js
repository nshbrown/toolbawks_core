/*
# Copyright (c) 2007 Nathaniel Brown
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
*/

Toolbawks.dialog = {
  msg_box : false,
  queue : [],
  
  create_box : function(t, s){
    return ['<div class="msg">',
            '<div class="x-box-tl"><div class="x-box-tr"><div class="x-box-tc"></div></div></div>',
            '<div class="x-box-ml"><div class="x-box-mr"><div class="x-box-mc"><h3>', t, '</h3>', s, '</div></div></div>',
            '<div class="x-box-bl"><div class="x-box-br"><div class="x-box-bc"></div></div></div>',
            '</div>'].join('');
  },
  
  msg : function(title, format){
    Toolbawks.log('Toolbawks.dialog.msg(title = "' + title + '", format = "' + format + '");');
      
    if (typeof Ext == 'undefined') {
      Toolbawks.warn('Toolbawks.dialog.msg -> Ext is undefined');
      return true;
    }
    
    if (!format) {
      format = title;
      title = "";
    }
    
    if (!Toolbawks.domready) {
      Toolbawks.dialog.add_to_queue(title, format);
    }
    
    if (!Toolbawks.dialog.msg_box) {
      Toolbawks.log('Toolbawks.dialog.msg -> !Toolbawks.dialog.msg_box');

// Prototype way
//        var msg_div = new Element('a', { 'id': 'msg-div' });
//        new Insertion.Top(document.body, msg_div);
//        Toolbawks.dialog.msg_box = $('msg_div');
      Toolbawks.dialog.msg_box = Ext.DomHelper.insertFirst(document.body, {id:'msg-div'}, true);
    }
    
    Toolbawks.dialog.msg_box.alignTo(document, 't-t');
    var s = String.format.apply(String, Array.prototype.slice.call(arguments, 1));
    var m = Ext.DomHelper.append(Toolbawks.dialog.msg_box, {html: Toolbawks.dialog.create_box(title, s)}, true);
    m.slideIn('t').pause(1).slideOut('t', {remove: true});
  },
  
  add_to_queue : function(t, f) {
    Toolbawks.dialog.queue[Toolbawks.dialog.queue.length] = { 
      title: t,
      format: f
    };
  },
  
  show_msg_queue : function() {
    if (Toolbawks.domready) {
      Toolbawks.dialog.queue.each(function(msg) {
        Toolbawks.info(title + ': ' + format);
        Toolbawks.msg(title, format);
      });
    } else {
      Toolbawks.warn('Toolbawks.dialog.show_msg_queue -> Toolbawks.domready not set yet');
    }
  },
  
  error : function (topic, message, internal) {
    Toolbawks.dialog.msg(topic, message);
    Toolbawks.console.error(internal + ' : ' + topic + ' : ' + message);
  },
  
  info : function (topic, message, internal) {
    Toolbawks.dialog.msg(topic, message);
  }
};

Toolbawks.msg = Toolbawks.dialog.msg;