require "spec_helper"

describe "regression test" do
  command("#{File.expand_path("../../../bin/foodcritic --tags any", __FILE__)} .", allow_error: true)

  IO.readlines(File.expand_path("../cookbooks.txt", __FILE__)).each do |line|
    name, ref = line.strip.split(":")

    context "with cookbook #{name}" do
      before do
        command("git clone -q https://github.com/chef-cookbooks/#{name}.git .")
        command("git checkout -q #{ref}")
      end

      it "should match expected output" do
        expected_output = IO.readlines(File.expand_path("../expected/#{name}.txt", __FILE__))
        expected_output.each do |expected_line|
          expect(subject.stdout).to include expected_line
        end
      end
    end
  end
end
