package com.springboot.crud.api;

import com.github.pagehelper.PageInfo;
import com.heptagram.core.common.rest.ResponseResult;
import com.springboot.crud.bean.user;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.springboot.crud.service.userService;
import javax.annotation.Resource;

@RestController
@RequestMapping("/api/user")
public class userApiController {
    @Resource
    private userService userService;
    @PostMapping("list")
    public ResponseResult list(@RequestBody user user){
        PageInfo<user> list=userService.findList(user);
        return new ResponseResult<>(list);
    }
    @PostMapping("update")
    public ResponseResult update(@RequestBody user user){
        userService.update(user);
        return new ResponseResult();
    }
    @PostMapping("insert")
    public ResponseResult insert(@RequestBody user user){
        userService.insert(user);
        return new ResponseResult();
    }
    @PostMapping("delete")
    public ResponseResult delete(@RequestBody user user){
        userService.delete(user);
        return new ResponseResult();
    }
}
