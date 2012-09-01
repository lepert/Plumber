require 'rexml/document'


class Loader
	attr_accessor :caption
end

class LoadXML<Loader
	def initialize(paths)
		@path=[]
		@reports=[]
		@reportpriority=[]
		@reportkey=[]
		@reportsum=[]
		@reportcreated=[]
		@reportupd=[]
		@str1=[]
		puts "Loading data..."
		@path=paths
		if RUBY_PLATFORM.downcase.include?("mswin")
      
			xml = REXML::Document.new(File.open("XML"+"\'"+@path[0]))
    		else
			xml = REXML::Document.new(File.open("XML"+"/"+@path[0]))
		end
		
		
		xml.elements.each("//priority") { |c| @reportpriority.push c.text }
		xml.elements.each("//key") { |c| @reportkey.push c.text }
		xml.elements.each("//summary") { |c| @reportsum.push c.text }
		xml.elements.each("//created") { |c| @reportcreated.push c.text }
		xml.elements.each("//updated") { |c| @reportupd.push c.text }
		@str1=[@reportpriority,@reportkey,@reportsum,@reportcreated,@reportupd]
@str1.transpose.map{|array|}		
p @str1
#@reports<<ReportObject.new(@reportkey,@reportpriority,@reportsum,@reportcreated,@reportupd)
	end
end

class SearcherFiles
	attr_accessor :pathsToFiles
end

class SearchXMLInFolder
	attr_reader :filesInFoulder
	def initialize
		@filesInFoulder=[]
		puts "Searching files..."
		#Работает если только запуск из тойже папки
		Dir.foreach('XML') { |filePath| @filesInFoulder.push filePath if filePath != "." && filePath != ".."}
		@filesInFoulder
	end
end

class XMLRepotsFactory
	attr_reader :searcher,:reportObjects
	def load
		findFiles
		loading
				
	end
	
	def loading
		LoadXML.new(@searher.filesInFoulder)
		
	end
	def findFiles
		@searher=SearchXMLInFolder.new
	end
end

class ReportObject
attr_reader :key,:priorityName,:summary,:created,:updated
	def initialze(key,priorityName,summary,created,updated)
		@key=key
		@priorityName=priorityName
		@summary=summary
		@created=created
		@updated=updated
	end
end





class ReportAbstract
	def initialize(factory)
		
		report=factory.load
		report.caption="hello!"
		
			
	end
end

class Report

	def self.run(formCommand)
		ReportAbstract.new(self.createSpecificReportsFactory(formCommand))
	end

	def self.createSpecificReportsFactory(formCommand)
		if formCommand=="formReportByPtiority"
			XMLRepotsFactory.new
		end	
	end	
end


class ReportsGenerator
	def takeReport()
	end
end

class TakeReportByPriority < ReportsGenerator 
	def takeReport()
		Report.run("formReportByPtiority")
	end
end

class TakeReportByUpdate < ReportsGenerator 
	def takeReport()
	puts "Метод по обновлению"
	end
end

class ReportAnalizer
	def initialize(method)
		 @method=method
		@reportGenerator=ReportsGenerator.new
	end

	def perform ()
		@reportGenerator.takeReport()	
	end
	def display()
		end
end

class ResponsingPeriodCounter <ReportAnalizer
	def initialize()

		@reportGenerator=TakeReportByPriority.new
	end

	def display()
		@reportGenerator.takeReport()
	end

end
g=ResponsingPeriodCounter.new
g.display()
	
