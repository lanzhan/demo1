package com.springboot.crud;


import com.springboot.crud.bean.user;
import com.springboot.crud.mapper.userMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.List;

@RunWith(SpringRunner.class)
@SpringBootTest
public class userMapperTest {

    @Resource
    private userMapper userMapper;

    @Test
    public void findList() {
        List<user> list = userMapper.select(new user());
    }
}

