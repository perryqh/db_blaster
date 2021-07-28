Rails.application.routes.draw do
  mount DbBlaster::Engine => "/db_blaster"
end
