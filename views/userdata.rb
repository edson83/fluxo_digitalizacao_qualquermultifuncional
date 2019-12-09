class UserData
  def self.import
    [
         # 1° Documento - newvar1
         {
		     :id => "RG",
             :name   => "RG",
			 :colormode => "Color",
			 :filetype => "pdf",
			 :resolution => "300",
			 :docsize => "BusinessCard",
			 :duplex => "true",
			 :url     => {
             :fin    => "/login"
		}
        },
         # 2° Documento
         {
             :id => "CPF",
             :name   => "CPF",
			 :colormode => "Color",
			 :filetype => "pdf",
			 :resolution => "300",
			 :docsize => "BusinessCard",
			 :duplex => "false",
			 :url     => {
             :fin    => "/login"
		}
        },
         # 3° Documento
         {
             :id => "CNH",
             :name   => "CNH",
			 :colormode => "Color",
			 :filetype => "pdf",
			 :resolution => "300",
			 :docsize => "BusinessCard",
			 :duplex => "true",
			 :url     => {
             :fin    => "/login"
		}
        },
			# 4° Documento
         {
             :id => "Comprovante de Residencia",
             :name   => "Comprovante de Residencia",
			 :colormode => "Mono",
			 :filetype => "pdf",
			 :resolution => "300",
			 :docsize => "A4",
			 :duplex => "true",
			 :url     => {
             :fin    => "/login"
		}
        },
			# 5° Documento
         {
             :id => "RA",
             :name   => "RA",
			 :colormode => "Color",
			 :filetype => "pdf",
			 :resolution => "300",
			 :docsize => "BusinessCard",
			 :duplex => "true",
			 :url     => {
             :fin    => "/login",
		}
        },
			# 6° Documento
         {
             :id => "Cartao",
             :name   => "Cartao",
			 :colormode => "Color",
			 :filetype => "pdf",
			 :resolution => "300",
			 :docsize => "BusinessCard",
			 :duplex => "true",
			 :url     => {
             :fin    => "/login",
		}
        },
			# 7° Documento
         {
             :id => "Historico",
             :name   => "Historico Escolar",
			 :colormode => "Color",
			 :filetype => "pdf",
			 :resolution => "300",
			 :docsize => "BusinessCard",
			 :duplex => "true",
			 :url     => {
             :fin    => "/login",
		}
        },
      ]
   end
end

class Group
   def initialize
      @user_hash = Hash.new
      import_userdata() 
   end

   def get_userinfo_by_id(id = nil)
      @user_hash[id] || nil
   end

   def get_list_of_all_users()
      ret = []
      @user_hash.keys.each { |id|
         ret << {
            :id => id,
            :name => @user_hash[id][:name]
         }
      }
      ret
   end
   def import_userdata()
      rawdata = UserData.import
      rawdata.each { |d|
         id = d[:id]
         @user_hash[id] = d
      }
	 
   end   
   end