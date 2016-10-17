RSpec::Matchers.define :have_scope do |scope_name, *args|
  match do |actual|
    actual.send(scope_name, *args).is_a?(actual::ActiveRecord_Relation)
  end

  failure_message do |actual|
    "Expected relation to have scope #{scope_name} #{args.present? ? "with args #{args.inspect}" : ""} but it didn't " + actual.send(scope_name).to_sql
  end

  failure_message_when_negated do |actual|
    "Expected relation not to have scope #{scope_name} #{args.present? ? "with args #{args.inspect}" : ""} but it didn't " + actual.send(scope_name).to_sql
  end

  description do
    "have scope #{scope_name} #{args.present? ? "with args #{args.inspect}" : ""}"
  end
end
