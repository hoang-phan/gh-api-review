require 'rails_helper'

RSpec.describe PatchHelper do
  describe '#process_patch' do
    let(:old_patch) { "@@ -10,3 +10,3 @@line 1\n+line 2\n-line 3\nline 4\n@@ -18,1 +18,2 @@+line 5\nline 6" }

    context 'patch is nil' do
      let(:old_patch) { nil }

      it 'returns empty string' do
        expect(described_class.modified_patch(old_patch)).to eq ''
      end
    end

    context 'patch is not nil' do
      let(:new_patch) { "\n...\n<span>   10</span> | <span>   10</span> | <span class=\"unchanged-line\">line 1</span>\n<span>     </span> | <span>   11</span> | <span class=\"added-line\">+line 2</span>\n<span>   11</span> | <span>     </span> | <span class=\"removed-line\">-line 3</span>\n<span>   12</span> | <span>   12</span> | <span class=\"unchanged-line\">line 4</span>\n...\n<span>     </span> | <span>   18</span> | <span class=\"added-line\">+line 5</span>\n<span>   18</span> | <span>   19</span> | <span class=\"unchanged-line\">line 6</span>" }

      it 'updates new patch' do
        expect(described_class.modified_patch(old_patch)).to eq new_patch
      end
    end
  end
end
