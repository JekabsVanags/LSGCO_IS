class User < ApplicationRecord
  has_secure_password

  enum rank: ["MZSK/GNT","SK/G", "DZSK/DZG", "ROV/LG", "VAD", "VIEDSK/VIEDG", "CITS"]
  enum activity_statuss: ["aktīvs", "interesents", "vecbiedrs"]
  enum sex: ["M", "F", "O"]
  enum permission_level: ["biedrs", "vaditajs", "valde"]

end
