var preloader = function()
{
  var frame_size = 19;

  var img = $('<img />')
    .css(
    {
      'backgroundImage': 'url(res/ajax.png)',
      'width' : frame_size,
      'height' : frame_size
    });

  var frame_delay = 0.1;
  var frames = 13;  

  var ret =
  {
    img : img
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

      this.img.css({'backgroundPosition' : -this.index * frame_size + 'px 0'});

      if (this.img.width() != undefined && this.img.attr('stop') != undefined)
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
