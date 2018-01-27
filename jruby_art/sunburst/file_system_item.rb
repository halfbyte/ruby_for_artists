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
#
# // This class code is based on code and ideas of chapter 7 in
# // Visualizing Data, First Edition by Ben Fry. Copyright 2008 Ben Fry, 9780596514556.



class FileSystemItem
  include Processing::Proxy

  attr_accessor :file, :children, :folderMinFilesize, :folderMaxFilesize
  MEGABYTE = 1048576.0

  # // ------ constructor ------
  def initialize(theFile)
    @file = theFile
    @folderMinFilesize = 0.0
    @folderMaxFilesize = 0.0

    if File.directory?(file)
      contents = Dir.entries(file)
      unless contents.empty?
        #// Sort the file names in case insensitive order
        contents = contents.sort_by(&:downcase)

        @children = []
        contents.each do |file_name|
          next if file_name == '.' || file_name == '..'
          next if file_name.match(/^\./)
          next if file_name.match(/tmp/)
          full_path = File.join(file, file_name)
          next if File.symlink?(full_path)
          child = FileSystemItem.new(full_path);
          @children << child
          size = child.getFileSize()
          @folderMinFilesize = [size, @folderMinFilesize].compact.min
          @folderMaxFilesize = [size, @folderMaxFilesize].compact.max
        end
        @children.each do |child|
          child.folderMinFilesize = @folderMinFilesize
          child.folderMaxFilesize = @folderMaxFilesize
        end
      end
    end
  end

  def childCount
    return 0 if @children.nil?
    @children.length
  end


  # // ------ get file size function ------
  # // how many MEGABYTE has my FileSystemItem
  def getFileSize()
    getRealFileSize(file) / MEGABYTE
  end

  def getRealFileSize(path)
    return File.size(path) if File.file?(path)
    total_size = 0
    if File.directory?(path)
      if Dir.entries(path).length > 2
        Dir.entries(path).each do |file_name|
          next if file_name == '.' || file_name == '..'
          next if file_name.match(/^\./)
          next if file_name.match(/tmp/)
          new_path = File.join(path, file_name)
          total_size += getRealFileSize(new_path)
        end
      end
    end
    total_size
  end

  # // ------ compare last file modification with current date function ------
  def getNotModifiedSince(path)
    # // get the date in milliseconds
    # // current file
    now = Time.now
    later = File.mtime(path)
    diff = later - now
    (diff / (24 * 60 * 60)).to_i
  end


  # // ------ print and debug functions ------
  # // Depth First Search
  def printDepthFirst()
    # println("printDepthFirst");
    # # // global fileCounter
    # @fileCounter = 0;
    # printRealDepthFirst(0,-1);
    # println(fileCounter+" files");
  end

  def printRealDepthFirst(depth, indexToParent)
    # # // print four spaces for each level of depth + debug println
    # for (int i = 0; i < depth; i++) print("    ");
    # println(fileCounter+" "+indexToParent+"<-->"+fileCounter+" ("+depth+") "+file.getName());
    #
    # indexToParent = fileCounter;
    # fileCounter++;
    #
    # // now handle the children, if any
    # for (int i = 0; i < childCount; i++) {
    #   children[i].printDepthFirst(depth+1,indexToParent);
    # }
  end



  # // Breadth First Search
  def printBreadthFirst()
    # println("printBreadthFirst");
    #
    # // queues for pushing and saving all elements in "breadth first search" style
    # ArrayList items = new ArrayList();
    # ArrayList depths = new ArrayList();
    # ArrayList indicesParent = new ArrayList();
    #
    # // add first elements and startingpoint
    # items.add(this);
    # depths.add(0);
    # indicesParent.add(-1);
    #
    # // tmp vars for running in while loop
    # int index = 0;
    # int itemCount = 1;
    #
    # while (itemCount > index) {
    #   FileSystemItem item = (FileSystemItem) items.get(index);
    #   int depth = (Integer) depths.get(index);
    #   int indexToParent = (Integer) indicesParent.get(index);
    #
    #   // print four spaces for each level of depth + debug println
    #   for (int i = 0; i < depth; i++) print("    ");
    #   println(index+" "+indexToParent+"<-->"+index+" ("+depth+") "+item.file.getName());
    #
    #   // is current node a directory?
    #   // yes -> push all children to the end of the items
    #   if (item.file.isDirectory()) {
    #     for (int i = 0; i < item.childCount; i++) {
    #       items.add(item.children[i]);
    #       depths.add(depth+1);
    #       indicesParent.add(index);
    #     }
    #     itemCount += item.childCount;
    #   }
    #   index++;
    # }
    # println(index+" files");
  end



  # // ------ init viz items function ------
  # // Breadth First
  def createSunburstItems()
    megabytes = getFileSize()
    anglePerMegabyte = Math::PI * 2 / megabytes

    # // temp array for pushing and saving all elements in "breadth first search" style
    items = []
    depths = []
    indicesParent = []
    sunburstItems = []
    angles = []

    # // add first elements and startingpoint
    items << self
    depths. << 0
    indicesParent << -1
    angles << 0.0

    # // tmp vars for running in while loop
    index = 0
    angleOffset = 0
    oldAngle = 0

    while (items.size > index)
      item = items[index]
      depth = depths[index]
      indexToParent = indicesParent[index]
      angle = angles[index]
      # //if there is an angle change (= entering a new directory) reset angleOffset
      angleOffset = 0.0 if (oldAngle != angle)

      # // is current node a directory?
      # // yes -> push all children to the end of the items
      if File.directory?(item.file)
        item.children.each do |child|
          items << child
          depths << (depth + 1)
          indicesParent << index
          angles << (angle + angleOffset)
        end
      end


      sunburstItems << SunburstItem.new(
        index, indexToParent, item.childCount, depth,
        item.getFileSize(), getNotModifiedSince(item.file),
        item.file, (angle+angleOffset) % (Math::PI * 2), item.getFileSize()*anglePerMegabyte,
        item.folderMinFilesize, item.folderMaxFilesize
      )

      angleOffset += item.getFileSize() * anglePerMegabyte;
      index += 1
      oldAngle = angle
    end

    #println(index+" SunburstItems");
    #// convert the arraylist to a normal array
    sunburstItems
  end
end
