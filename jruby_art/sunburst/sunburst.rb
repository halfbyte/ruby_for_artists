load_library :controlP5
include_package 'controlP5'

java_import java.lang.System

require_relative 'gui'
require_relative 'file_system_item'
require_relative 'sunburst_item'

attr_accessor :mappingMode, :hueStart, :hueEnd, :saturationStart, :saturationEnd,
    :brightnessStart, :brightnessEnd, :folderBrightnessStart, :folderBrightnessEnd,
    :folderStrokeBrightnessStart, :folderStrokeBrightnessEnd, :fileArcScale, :folderArcScale,
    :strokeWeightStart, :strokeWeightEnd, :dotSize, :dotBrightness, :backgroundBrightness,
    :showArcs, :showLines, :useArc, :useBezierLine, :showGUI


$depthMax = 0
$lastModifiedOldest = nil
$lastModifiedYoungest = nil
$fileSizeMin = nil
$fileSizeMax = nil
$childCountMin = nil
$childCountMax = nil
$fileCounter = 0



def settings
  size 1000, 800
end

def setup
  sketch_title 'Sunburst Thing press o to select an input folder'
  setup_variables
  # setup_gui
  color_mode HSB, 360, 100, 100
  @font = create_font('miso-regular', 14)
  text_font(@font, 12)
  text_leading 14
  text_align LEFT, TOP
  cursor CROSS

  set_input_folder "/Users/jan/Documents/projects/golfwart/golfwart/app"

end

def default_folder_path
  System.getProperty("user.home") + "/Desktop"
end

def setup_variables
  @hueStart = 273
  @hueEnd = 323;
  @saturationStart = 73
  @saturationEnd = 100;
  @brightnessStart = 51
  @brightnessEnd = 77;
  @folderBrightnessStart = 20
  @folderBrightnessEnd = 90;
  @folderStrokeBrightnessStart = 20
  @folderStrokeBrightnessEnd = 90;
  @fileArcScale = 1.0
  @folderArcScale = 0.2;
  @strokeWeightStart = 0.5
  @strokeWeightEnd = 1.0;
  @dotSize = 3
  @dotBrightness = 1;
  @backgroundBrightness = 100;
  @mappingMode = 1

  @useArc = true;
  @useBezierLine = true;
  @showArcs = true;
  @showLines = true;
  #@savePDF = false;
  @showGUI = false

end

def draw
  push_matrix
  color_mode HSB, 360, 100, 100
  background 0, 0, backgroundBrightness
  no_fill
  ellipse_mode(RADIUS)
  stroke_cap(SQUARE)
  text_font(@font,12)
  text_leading(14)
  text_align(LEFT, TOP)
  smooth()

  translate(width/2, height/2)

  #  ------ mouse rollover, arc hittest vars ------
  hitTestIndex = -1
  mX = mouseX-width/2
  mY = mouseY-height/2
  mAngle = atan2(mY-0, mX-0)
  mRadius = dist(0,0, mX,mY)
  if mAngle < 0
    mAngle = map(mAngle,-PI,0,PI,TWO_PI)
  else
    mAngle = map(mAngle,0,PI,0,PI)
  end
  # calc mouse depth with mouse radius ... transformation of calcEqualAreaRadius()
  mDepth = ((mRadius ** 2)*($depthMax+1)/((height*0.5) ** 2)).floor


  # ------ draw the viz items ------
  $sunburst.each_with_index do |sb, i|
    if showArcs
      if useArc
        sb.drawArc(folderArcScale, fileArcScale)
      else
        sb.drawRect(folderArcScale, fileArcScale)
      end
    end

    # hittest, which arc is the closest to the mouse
    if sb.depth == mDepth
      if mAngle > sb.angleStart && mAngle < sb.angleEnd
        hitTestIndex=i
      end
    end
  end
  0.upto($sunburst.length - 1) do |i|
    # draw arcs or rects
  end

  if (showLines)
    $sunburst.each do |sb|
      if (useBezierLine)
        sb.drawRelationBezier()
      else
        sb.drawRelationLine()
      end
    end
  end

  $sunburst.each do |sb|
    sb.drawDot()
  end

  # ------ mouse rollover ------
  if (showGUI == false)
    # depth level focus
    if (mDepth <= $depthMax)
      r1 = calcEqualAreaRadius(mDepth,$depthMax)
      r2 = calcEqualAreaRadius(mDepth+1,$depthMax)
      stroke(0,0,0,30)
      stroke_weight(5.5)
      ellipse(0,0,r1,r1)
      ellipse(0,0,r2,r2)
    end
    # rollover text
    if(hitTestIndex != -1)
      tex = $sunburst[hitTestIndex].name + "\n"
      fs_formatted = ("%.1f" % [$sunburst[hitTestIndex].fileSize])
      tex += fs_formatted
      tex += $sunburst[hitTestIndex].lastModified.to_s + " days | "
      tex += $sunburst[hitTestIndex].childCount.to_s + " kids"
      texW = text_width(tex) * 1.2
      fill(0,0,0);
      offset = 5;
      rect(mX+offset,mY+offset,texW+4,text_ascent()*3.6)
      fill(0,0,100)
      text(tex.upcase(),mX+offset+2,mY+offset+2)

    end
  end

  pop_matrix();
  #draw_gui();
end

# ------ folder selection dialog + init visualization ------
def set_input_folder_by_file(selection)
  set_input_folder(theFolder.to_s)
end

def set_input_folder(theFolderPath)
  # get files on harddisk
  #println("\n"+theFolderPath);
  selectedFolder = FileSystemItem.new(theFolderPath)
  # selectedFolder.printDepthFirst();
  # selectedFolder.printBreadthFirst();

  # init sunburst
  $sunburst = selectedFolder.createSunburstItems()

  # mine sunburst -> get min and max values
  # reset the old values, without the root element
  $depthMax = 0
  $lastModifiedOldest = $lastModifiedYoungest = 0
  $fileSizeMin = $fileSizeMax = 0
  $childCountMin = $childCountMax = 0
  $sunburst.each do |sb|
    $depthMax = max(sb.depth, $depthMax);
    $lastModifiedOldest = max(sb.lastModified, $lastModifiedOldest);
    $lastModifiedYoungest = min(sb.lastModified, $lastModifiedYoungest);
    $fileSizeMin = min(sb.fileSize, $fileSizeMin);
    $fileSizeMax = max(sb.fileSize, $fileSizeMax);
    $childCountMin = min(sb.childCount, $childCountMin);
    $childCountMax = max(sb.childCount, $childCountMax);
  end

  # update vars
  $sunburst.each do |sb|
    sb.update(mappingMode)
  end
end


# ------ returns radiuses to have equal areas in each depth ------
def calcEqualAreaRadius (theDepth, theDepthMax)
  sqrt(theDepth * ((height/2) ** 2) / (theDepthMax+1))
end

# ------ returns radiuses in a linear way ------
def calcAreaRadius (theDepth, theDepthMax)
  map(theDepth, 0,theDepthMax+1, 0,height/2)
end

def map(val, min1, max1, min2, max2)
  map1d(val, (min1..max1), (min2..max2))
end


# ------ interaction ------
def key_released
  save_frame(timestamp()+"_##.png") if (key == 's' || key == 'S')

  # savePDF = true if (key == 'p' || key == 'P')
  select_input("please select a file", "fileSelected")
  #select_folder("please select a folder", 'setInputFolderByFile') if (key == 'o' || key == 'O')

  if (key == '1')
    mappingMode = 1;
    frame.set_title("last modified: old / young files, global");
  end

  if (key == '2')
    mappingMode = 2;
    frame.set_title("file size: big / small files, global");
  end
  if (key == '3')
    mappingMode = 3;
    frame.set_title("local folder file size: big / small files, each folder independent")
  end

  if (key == '1' || key == '2' || key == '3')
    $sunburst.each do |sb|
      sb.update(mappingMode)
    end
  end

  # if (key=='m' || key=='M')
  #   showGUI = controlP5.getGroup("menu").isOpen();
  #   showGUI = !showGUI;
  # end
  #
  # if (showGUI) controlP5.getGroup("menu").open();
  # else controlP5.getGroup("menu").close();
end

def mouse_entered(e)
  loop();
end

def mouse_exited(e)
  no_loop()
end

def fileSelected(selection)
  #puts selection.inspect
end

def timestamp()
  Time.now.strftime('%Y%m%d_%H%M%S')
end
