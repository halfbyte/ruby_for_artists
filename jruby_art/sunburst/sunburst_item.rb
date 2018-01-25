# // M_5_5_01_TOOL.pde
# // FileSystemItem.pde, GUI.pde, SunburstItem.pde
# //
# // Generative Gestaltung, ISBN: 978-3-87439-759-9
# // First Edition, Hermann Schmidt, Mainz, 2009
# // Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
# // Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
# //
# // http://www.generative-gestaltung.de
# //
# // Licensed under the Apache License, Version 2.0 (the "License");
# // you may not use this file except in compliance with the License.
# // You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
# // Unless required by applicable law or agreed to in writing, software
# // distributed under the License is distributed on an "AS IS" BASIS,
# // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# // See the License for the specific language governing permissions and
# // limitations under the License.

class SunburstItem
  include Processing::Proxy


  attr_reader :depth, :index, :indexToParent, :childCount, :file,
                :name, :isDir, :lastModified, :fileSize, :folderMinFilesize,
                :folderMaxFilesize, :col, :lineCol, :lineWeight, :angleStart,
                :angleCenter, :angleEnd, :extension, :radius, :depthWeight,
                :x, :y, :arcLength, :c1X, :c1Y, :c2X, :c2Y
  # File file;

  # // relations
  # int depth;
  # int index;
  # int indexToParent;
  # int childCount;
  #
  # // meta file informations
  # String name;
  # boolean isDir;
  # int lastModified; // age of the file in days
  # float fileSize;
  # float folderMinFilesize; // biggest an smallest file in the same folder
  # float folderMaxFilesize;
  #
  # // arc and lines drawing vars
  # color col;
  # color lineCol;
  # float lineWeight;
  # float angleStart, angleCenter, angleEnd;
  # float extension;
  # float radius;
  # float depthWeight; // stroke weight of the arc
  # float x,y;
  # float arcLength;
  # float c1X,c1Y,c2X,c2Y; // bezier controlpoints

  # // ------ constructor ------
  def initialize(theIndex, theIndexToParent, theChildCount, theDepth, theFileSize, theLastModified, theFile, theAngle, theExtension, theFolderMinFilesize, theFolderMaxFilesize)

    @depth = theDepth;
    @index = theIndex;
    @indexToParent = theIndexToParent;

    file = theFile;
    @file = file
    @name = File.basename(file)
    @isDir = File.directory?(file)
    @lastModified = theLastModified;
    @fileSize = theFileSize;
    @childCount = theChildCount;
    @folderMinFilesize = theFolderMinFilesize;
    @folderMaxFilesize = theFolderMaxFilesize;

    # // sunburst angles and extension
    @angleStart = theAngle;
    @extension = theExtension;
    @angleCenter = theAngle + theExtension/2;
    @angleEnd = theAngle + theExtension;
    puts "Angles: #{@angleStart}, #{@angleEnd}"
  end



  # // ------ update function, called only when the input files are changed ------
  def update(theMappingMode)
    if (@indexToParent > -1)
      @radius = calcEqualAreaRadius(@depth, $depthMax)
      puts "RADIUS: #{@radius}, #{@depth}, #{$depthMax}"
      @depthWeight = calcEqualAreaRadius(@depth+1,$depthMax) - @radius
      @x  = cos(@angleCenter) * @radius;
      @y  = sin(@angleCenter) * @radius;

      # // chord
      startX  = cos(@angleStart) * radius;
      startY  = sin(@angleStart) * radius;
      endX  = cos(@angleEnd) * radius;
      endY  = sin(@angleEnd) * radius;
      @arcLength = dist(startX,startY, endX,endY);

      # // color mapings
      percent = 0;
      case(theMappingMode)
      when 1
        percent = norm(@lastModified, $lastModifiedOldest, $lastModifiedYoungest)
      when 2
        percent = norm(@fileSize, $fileSizeMin, $fileSizeMax);
      when 3
        percent = norm(@fileSize, $folderMinFilesize, $folderMaxFilesize)
      end

      # // colors for files and folders
      puts "#{file}>#{isDir}"
      if (isDir)
        bright = 0;
        bright = lerp(folderBrightnessStart,folderBrightnessEnd,percent);
        puts "DIR: #{bright}"
        @col = color(0,0,bright);
        bright = lerp(folderStrokeBrightnessStart,folderStrokeBrightnessEnd,percent);
        puts "DIR LINE: #{bright}"
        @lineCol = color(0,0,bright);
      else
        from = color(hueStart, saturationStart, brightnessStart);
        to = color(hueEnd, saturationEnd, brightnessEnd);
        @col = lerp_color(from, to, percent);
        puts "COL: #{@col}"
        @lineCol = @col;
      end

      # // calc stroke weight for relations line
      @lineWeight = map(@depth, $depthMax, 1, strokeWeightStart, strokeWeightEnd)
      @lineWeight = arcLength * 0.93 if (arcLength < @lineWeight)

      # // calc bezier controlpoints
      @c1X  = cos(@angleCenter) * calcEqualAreaRadius(@depth-1, $depthMax);
      @c1Y  = sin(@angleCenter) * calcEqualAreaRadius(@depth-1, $depthMax);

      @c2X  = cos($sunburst[@indexToParent].angleCenter);
      @c2X *= calcEqualAreaRadius(@depth, $depthMax);

      @c2Y  = sin($sunburst[@indexToParent].angleCenter);
      @c2Y *= calcEqualAreaRadius(@depth, $depthMax);
    end
  end


  # def calcEqualAreaRadius (theDepth, theDepthMax)
  #   sqrt(theDepth * (height/2 ** 2) / (theDepthMax+1))
  # end
  #
  # # ------ returns radiuses in a linear way ------
  # def calcAreaRadius (theDepth, theDepthMax)
  #   map(theDepth, 0,theDepthMax+1, 0,height/2)
  # end



  # // ------ draw functions ------
  def drawArc(theFolderScale, theFileScale)
    arcRadius = 0
    if (@depth > 0 )
      if (isDir)
        stroke_weight(@depthWeight * theFolderScale);
        arcRadius = radius + @depthWeight*theFolderScale/2;
      else
        stroke_weight(depthWeight * theFileScale);
        arcRadius = radius + depthWeight*theFileScale/2;
      end
      #puts "ST: #{@col}, #{@angleStart}, #{@angleEnd}"
      stroke(@col);
      # //arc(0,0, arcRadius,arcRadius, angleStart, angleEnd);
      arcWrap(0,0, arcRadius, arcRadius, @angleStart, @angleEnd); # normaly arc should work
    end
  end

  # // fix for arc
  # // it seems that the arc functions has a problem with very tiny angles ...
  # // arcWrap is a quick hack to get rid of this problem
  def arcWrap(theX, theY, theW, theH, theA1, theA2)
    if (@arcLength > 2.5)
      arc(theX,theY, theW, theH, theA1, theA2);
    else
      stroke_weight(@arcLength);
      push_matrix();
      rotate(@angleCenter);
      translate(@radius,0);
      line(0,0, (theW-@radius)*2,0);
      pop_matrix();
    end
  end

  def drawRect(theFolderScale, theFileScale)
    float rectWidth;
    if (@depth > 0 )
      if (@isDir)
        rectWidth = @radius + @depthWeight*theFolderScale/2;
      else
        rectWidth = @radius + @depthWeight*theFileScale/2;
      end
      stroke(@col);
      stroke_weight(@arcLength);
      push_matrix();
      rotate(@angleCenter);
      translate(@radius,0);
      line(0,0, (rectWidth-@radius)*2,0);
      pop_matrix();
    end
  end


  def drawDot()
    if (@depth > 0)
      diameter = dotSize;
      diameter = @arcLength*0.95 if (@arcLength < diameter)
      diameter = 3 if (@depth == 0)
      fill(0,0, dotBrightness)
      no_stroke
      ellipse(x,y,diameter,diameter)
      no_fill
    end
  end


  def drawRelationLine()
    if (@depth > 0)
      stroke(@lineCol);
      strokeWeight(@lineWeight);
      line(x,y, $sunburst[@indexToParent].x, $sunburst[@indexToParent].y)
    end
  end


  def drawRelationBezier()
    if (@depth > 1)
      stroke(@lineCol);
      strokeWeight(@lineWeight);
      bezier(@x,@y, @c1X,@c1Y, @c2X,@c2Y, $sunburst[@indexToParent].x, $sunburst[@indexToParent].y)
    end
  end

end
