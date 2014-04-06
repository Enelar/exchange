var preloader = function()
{
  var frame_size = 19;

  var id = phoxy.GenerateUniqueID();
  var img = $('<div />')
    .attr('id', id)
    .css(
    {
      'backgroundImage': 'url(res/ajax.png)',
      'width' : frame_size,
      'height' : frame_size
    });

  var frame_delay = 100;
  var frames = 13;  

  var ret =
  {
    id : '#' + id  
    ,
    StartAnimation : function()
    {
      phoxy.Defer.call(this, this.ContinueAnimation, frame_delay);
    }
    ,  
    index: 0
    ,
    ContinueAnimation : function()
    {
      this.index++;
      
      if (this.index >= frames)
        this.index = 0;

      if (this.img == undefined)
      {
        var selector = $(this.id);
        if (selector[0] == undefined)        
          return phoxy.Defer.call(this, this.ContinueAnimation, frame_delay);
        this.img = selector;
      }

      this.img.css({'backgroundPosition' : -this.index * frame_size + 'px 0'});

      if (this.img.width() != undefined && this.img.attr('stop') == undefined)
        phoxy.Defer.call(this, this.ContinueAnimation, frame_delay);
    }
    ,
    StopAnimation : function()
    {
      this.img.attr('stop', 'true');
    }
  };
  ret.StartAnimation();
  return img.wrapAll($('<div />')).parent().html();
};
