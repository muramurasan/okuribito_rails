require "yaml"

module OkuribitoRails
  class RegistMethod
    def update_observe_methods(path)
      input = yaml_to_array(path)
      base  = db_to_array
      new_methods = input - base
      new_methods.each { |new_method| regist_method(new_method) }
      old_methods = base - input
      old_methods.each { |old_method| destroy_method(old_method) }
    end

    private

    def yaml_to_array(path)
      yaml = YAML.load_file(path)
      methods_array = []
      yaml.each do |class_name, observe_methods|
        observe_methods.each do |observe_method|
          methods_array.push(class_name + observe_method)
        end
      end
      methods_array
    end

    def db_to_array
      methods_array = []
      results = MethodCallSituation.all
      results.each do |result|
        methods_array.push(result.class_name + result.method_symbol + result.method_name)
      end
      methods_array
    end

    def regist_method(method)
      a = method.split(/\s*(#|\.)\s*/)
      MethodCallSituation.create(class_name: a[0], method_symbol: a[1], method_name: a[2])
    end

    def destroy_method(method)
      a = method.split(/\s*(#|\.)\s*/)
      MethodCallSituation.find_by(class_name: a[0], method_symbol: a[1], method_name: a[2])&.destroy
    end
  end
end
