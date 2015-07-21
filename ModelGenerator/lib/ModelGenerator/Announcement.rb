#  .eg
#
#  CKAppleItemModel.h
#  ProjectTemple
#
#  Created by Mac on 14-5-26.
#  Copyright (c) 2014年 Mac. All rights reserved.
#

class Announcement
  attr_accessor :name
  attr_accessor :projectName
  attr_accessor :author
  
  def initialize
    @projectName="your_project_name"
    @author="CK"
    @name="entity_name"
  end
  
  def createDeclare
    return "//\n//  #{@name}.h\n//  #{@projectName}\n//\n//  Created by #{@author} on #{t=Time.now ; t.strftime("%y-%m-%d")}.\n\
//  Copyright (c) #{t=Time.now ; t.strftime("%Y")}年 #{@author}. All rights reserved."
  end
end
