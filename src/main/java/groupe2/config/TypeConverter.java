package groupe2.config;

import groupe2.entity.Type;
import groupe2.service.TypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

@Component
public class TypeConverter implements Converter<String, Type>{
    @Autowired
    private TypeService typeService;

    @Override
    public Type convert(String id) {
        if (id == null || id.isEmpty()) {
            return null;
        }
        return typeService.findById(Long.parseLong(id));
    }
}
