module UploaderStore

   def store_dir
     $q('uploads/#{ENV[\'RAILS_ENV\']}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}')
   end

end