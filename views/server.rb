require 'rubygems'
require 'sinatra'
require 'haml'
require 'rexml/document'
require './views/userdata'

set :port, 808
set :bind, "#{$ip_server}"
 
enable :sessions 
def clear_cookie
   session[:variable1] = nil
   session[:variable2] = nil
end

def build_ui_for(endpoint7)
		(variable1, variable2) = [session[:variable1], session[:variable2]]
		$newdir = variable1
		$newfor = ".pdf"
		$divider = "_"
	   @param = Hash.new
	   @param[:cmds] = []
	   case endpoint7  
	   when "variable1"	 
			@param = {
			 :pagetitle   => "pagetitle",
			 :submit      => "./result",
			 :back        => "./init",  
			 :objtitle    => "Digite o nome do Funcionario: ",
			 :description => "Digite o nome do Funcionario:",
			 :id          => "p_variable1",
		}
			return haml :keyboard	
	   when "result"
			 @param = {
			 :pagetitle   => "Criar Pasta", 
			 :submit      => "./login",
			 :back        => "./variable1",  
		}
       if File.exist?("C:\\DigitalFlux\\Funcionarios\\#{$newdir}")  
				@param[:objtitle] = "Usuario já existe"
				@param[:msgbody] =  "O usuario #{$newdir} já existe. Pressione [Ok] para continuar ou [Voltar] para escolher ou funcionario."
	   else
			Dir.mkdir("C:\\DigitalFlux\\Funcionarios\\#{$newdir}")
			@param[:objtitle] = "Novo usuario"
			 @param[:msgbody] =  "O usuario #{$newdir} foi criado com sucesso. Pressione [Ok] para continuar ou [Voltar] para escolher ou funcionario."
		 end
		return haml :message
		
	when "login"
   @param = Hash.new
   @param[:submit] = "./auth"
      @param[:back] = "./init"
   @param[:userid] = {
      :objtitle => "Escolha seu documento",
      :description => "Escolha seu documento",
      :users => settings.users.get_list_of_all_users()
   }
   return haml :menu
   end 
end
def get_id_pass_from(xml)
   kvarray = parse_user_input(xml)
   return nil unless kvarray
   ret = nil
   kvarray.each { |kv|
      if kv[:key] == "userid"
         ret = Hash.new unless ret
         ret[:id] = kv[:value]
      end
   }
   puts "Parsed info/ id:#{ret[:id]}" if settings.debug
   ret
end
def parse_user_input(xml)
   array = Array.new
   doc = REXML::Document.new(xml)
   begin
      doc.elements.each('SerioEvent/UserInput/UserInputValues/KeyValueData')  { |kv| 
	  array << {
            :key   => kv.elements['Key'].text,
            :value => kv.elements['Value'].text
         }
      }
   rescue
      puts "PARSE ERROR OCCURRED."
   end
   array
end

post "/auth" do
   xmlstr = params[:xml].to_s
   puts xmlstr if settings.debug
   idpass = get_id_pass_from(xmlstr)
   @param = settings.users.get_userinfo_by_id(idpass[:id])
   content_type :xml
	@param[:store] = "#{$newdir}"
	@param[:host]  = "#{$ip_server}"
	@param[:user] = "anonymous"
	@param[:pass] = "brother"
	@param[:passive] = "true"
	@param[:port] = "29"
	$newvar = @param[:id]
	@param[:name_scan] = "#{$newvar}#{$divider}#{$newdir}"
	return haml :cmd_scansend
    end
		
configure do
   set :users, Group.new
   set :debug, true
end
get "/init" do
   content_type :xml
   build_ui_for("variable1")
end
post "/init" do
   content_type :xml
   build_ui_for("variable1")
end
get "/:endpoint7" do
   content_type :xml
   build_ui_for(params[:endpoint7])
end
post "/:endpoint7" do
   keyvalues = parse_user_input(params[:xml].to_s)
   keyvalues.each { |kv|
      case kv[:key]
      when "p_variable2"
         session[:variable2] = kv[:value].to_s
      when "p_variable1"
         session[:variable1] = kv[:value].to_s
      end
   }
   content_type :xml
   build_ui_for(params[:endpoint7])
end


