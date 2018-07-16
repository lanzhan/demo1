package com.springboot.crud.service.Impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.springboot.crud.bean.user;
import com.springboot.crud.mapper.userMapper;
import com.springboot.crud.service.userService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class userServiceImpl implements userService {

    @Resource
    private userMapper userMapper;
    @Override
    public void insert(user user) {
        userMapper.insert(user);
    }

    @Override
    public PageInfo<user> findList(user user) {
        PageHelper.startPage(user.getPage(),user.getPageSize());
        List<user> users=userMapper.select(user);
        return new PageInfo<user>(users);
    }

    @Override
    public void update(user user) {
        userMapper.update(user);
    }

    @Override
    public void delete(user user) {
        userMapper.delete(user);
    }
}
