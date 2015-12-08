class FileChange < ActiveRecord::Base
  belongs_to :commit

  before_create :process_patch

  private

  def process_patch
    self.patch = PatchHelper.modified_patch(patch)
  end
end
