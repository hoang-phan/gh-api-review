class FileChange < ActiveRecord::Base
  belongs_to :commit

  before_create :process_patch

  private

  def process_patch
    self.line_changes = PatchHelper.build_patch(patch)
  end
end
