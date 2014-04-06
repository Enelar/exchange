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
    index: 0
    ,
    StartAnimation : function()
    {
      this.index++;
      
      var max_fault_seconds = 10;
      if (this.index > max_fault_seconds * 1000 / frame_delay)
        return;

      var selector = $(this.id);
      if (selector[0] == undefined)
        return phoxy.Defer.call(this, this.StartAnimation, frame_delay);
      this.img = selector;
      this.Animation();
    }
    ,
    Animation : function()
    {
      this.index++;
      
      if (this.index >= frames)
        this.index = 0;

      this.img.css({'backgroundPosition' : -this.index * frame_size + 'px 0'});

      if (this.img.width() != undefined)
        phoxy.Defer.call(this, this.Animation, frame_delay);
    }
  };
  ret.StartAnimation();
  return img.wrapAll($('<div />')).parent().html();
};
